package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AppTest {

    @Test
    void testIsEven() {
        assertTrue(App.isEven(4), "4 should be even");
        assertFalse(App.isEven(5), "5 should not be even");
    }
}
