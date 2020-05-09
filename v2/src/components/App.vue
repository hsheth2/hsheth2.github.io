<template>
        <div id="app">
            <!--    <HelloWorld msg="Welcome to Your Vue.js App"/>-->
            <Container>
                <Navbar></Navbar>
            </Container>

            <Projects></Projects>
        </div>
</template>

<script>
    // import HelloWorld from './components/HelloWorld.vue'
    import Navbar from "./Navbar.vue";
    import Container from "./Container";
    import Projects from "./Projects";

    export default {
        name: "App",
        components: {
            // HelloWorld
            Container,
            Navbar,
            Projects,
        }
    }
</script>

<style scoped>

</style>