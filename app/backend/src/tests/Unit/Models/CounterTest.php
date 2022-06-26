<?php

namespace Tests\Unit\Models;

use App\Models\Counter;
use PHPUnit\Framework\TestCase;

class CounterTest extends TestCase
{
    /**
     * @return void
     */
    public function test_counter()
    {
        $counter = new Counter();
        $counter->addNumber(10);
        $this->assertEquals(10, $counter->count);

        $counter = new Counter();
        $counter->count = 1;
        $counter->addNumber(10);
        $this->assertEquals(11, $counter->count);

        $counter = new Counter();
        $counter->count = 1;
        $counter->addNumber(-10);
        $this->assertEquals(1, $counter->count);
    }
}
