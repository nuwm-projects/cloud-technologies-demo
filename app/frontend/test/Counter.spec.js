import {describe, expect, jest, test} from "@jest/globals";
import {mount} from "@vue/test-utils";
import Counter from "@/components/Counter";
import Vue from "vue";
import {BootstrapVue} from 'bootstrap-vue'

Vue.use(BootstrapVue);

describe('Counter', () => {
    let wrapper;

    const createComponent = (config) => {
        wrapper = mount(Counter, config);
    }


    test('Test rendered component', () => {
        createComponent({
            mocks: {
                $axios: {
                    get: jest.fn(() => Promise.resolve({data: {count: 1}}))
                }
            }
        });

        expect(wrapper).toMatchSnapshot();
    });

    test('Press increment', async () => {
        createComponent({
            mocks: {
                $axios: {
                    get: jest.fn(() => Promise.resolve({data: {count: 1}})),
                    post: jest.fn(),
                }
            }
        });

        await wrapper.find('a[role="button"]').trigger('click');
        await wrapper.vm.$nextTick();

        expect(wrapper.find('.counter-number').text()).toBe('1');
    });
});
