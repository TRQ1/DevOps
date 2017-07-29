import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';
import { ReactiveDict } from 'meteor/reactive-dict';

import { Tasks } from '../api/tasks.js';

import './task.js';
import './body.html';

Template.body.onCreated(function bodyOncreated() {
    this.state = new ReactiveDict();
    Meteor.subscribe('tasks');
});

Template.body.helpers({
    tasks() {
        const instance = Template.instance();
        if (instance.state.get('hideCompleted')) {
            console.log("숨기기 활성화 -> 다시 렌더링");
            return Tasks.find({ checked: { $ne: true } }, { sort: { createdAt: -1  }});
        }
            console.log("숨기기 비활성화 -> 다시 렌더링");
        return Tasks.find({}, { sort: { createdAt: -1 } });
    },
    incompleteCount() {
        const count = Tasks.find({ checked: { $ne: true } }).count();
        console.log("count: " + count);
        return count;
    },
});

Template.body.events({
    'submit .new-task'(event) {
        event.preventDefault();

        const target = event.target;
        const text = target.text.value;

        Meteor.call('tasks.insert', text);

        target.text.value = '';
    },
    'change .hide-completed input'(event, instance) {
        console.log("숨기기 플래그 변경됨: " + event.target.checked);
        instance.state.set('hideCompleted', event.target.checked);
    }
});