<template>
    <div class="container is-centered">
        <div class="limit-max-size">
            <slot></slot>
        </div>
    </div>
</template>

<script>
    export default {
        name: "Container"
    }
</script>

<style scoped>
.limit-max-size {
    max-width: 768px;
    margin-left: auto;
    margin-right: auto;
}
</style>