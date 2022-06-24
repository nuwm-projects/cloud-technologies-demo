<template>
    <div class="d-flex justify-content-center">
        <b-card
            title="Counter"
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
        >

            <b-card-text>
                {{ counter }}
            </b-card-text>

            <b-button href="#" variant="primary" @click="plus">Plus</b-button>
        </b-card>
    </div>
</template>

<script>
import apiConfig from '@/api/url.json'

export default {
    name: 'Counter',
    data() {
        return {
            counter: 0,
        }
    },
    mounted() {
        this.$axios.get(apiConfig.url + '/api/counter')
            .then((response) => {
                console.log(response)
                this.counter = response.data.count;
            });
    },
    methods: {
        async plus() {
            this.counter++;

            await this.$axios.post(apiConfig.url + '/api/counter', {
                count: 1,
            })
        },
    }
}
</script>
