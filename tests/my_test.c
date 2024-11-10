/*
** EPITECH PROJECT, 2024
** test units
** File description:
** Unit tests for the github actions
*/

#include <criterion/criterion.h>
#include <criterion/redirect.h>

Test (main_test, test_a, .init = cr_redirect_stdout) {
    cr_assert_eq(11, 12);
}
