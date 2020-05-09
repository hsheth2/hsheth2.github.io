<template>
    <b-navbar class="has-shadow">
        <template slot="brand">
            <b-navbar-item tag="router-link" :to="{ path: '/' }">
                <span class="is-size-3">
                    <a href="/" class="has-text-weight-light">Harshal Sheth</a>
                </span>
            </b-navbar-item>
        </template>
        <template slot="start">
        </template>

        <template slot="end">
            <b-navbar-item href="#">
                About
            </b-navbar-item>
            <b-navbar-item href="#">
                Projects
            </b-navbar-item>
        </template>
    </b-navbar>
</template>

<script>
    export default {
        name: "Navbar"
    }
</script>

<style scoped>

</style>