<?php declare(strict_types=1); function excerpt(string $text, int $length = 140): string { return e(mb_strimwidth($text, 0, $length, '…')); }
