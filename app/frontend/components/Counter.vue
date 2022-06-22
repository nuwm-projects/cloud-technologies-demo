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
export default {
    name: 'Counter',
    data() {
        return {
            counter: 0,
        }
    },
    mounted() {
        this.$axios.get('/counter')
            .then((response) => {
                this.counter = response.counter;
            });
    },
    methods: {
        async plus() {
            this.counter++;

             await this.$axios.put('/counter', {
                counter: this.counter,
            })
        },
    }
}
</script>
