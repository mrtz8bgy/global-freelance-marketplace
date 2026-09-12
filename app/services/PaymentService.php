<?php
declare(strict_types=1);

final class PaymentService
{
    public function createCheckout(array $contract) { throw new LogicException('Payment provider adapter is not configured.'); }
}
