<?php declare(strict_types=1); function human_date(string $date): string { return date('M j, Y', strtotime($date)); }
