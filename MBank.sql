CREATE TABLE `historique_bank` (
  `id` int(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `numero` varchar(255) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `bank_account` (
  `id` int(255) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `account_password` varchar(255) NOT NULL,
  `typecompte` varchar(255) NOT NULL,
  `money` varchar(255) NOT NULL DEFAULT '0',
  `createby` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `historique_bank`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `bank_account`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `bank_account`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

ALTER TABLE `historique_bank`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
COMMIT;
