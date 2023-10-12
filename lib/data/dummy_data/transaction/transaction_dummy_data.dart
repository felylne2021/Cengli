import 'package:cengli/data/modules/transactional/model/bill.dart';
import 'package:cengli/data/modules/transactional/model/expense.dart';

List<Expense> expenses = const [
  Expense(
      id: '0',
      title: 'Settle Up to @Steve',
      amount: '20.25 USDT',
      category: 'food',
      date: '9 Oct 2023, 17:45PM',
      groupId: '0'),
  Expense(
      id: '1',
      title: 'McDonalds BSD',
      amount: '10.2 USDT',
      category: 'food',
      date: '19 Sept 2023, 15:02PM',
      groupId: '1'),
  Expense(
      id: '2',
      title: 'Settlement from Michael',
      amount: '30.82 USDC',
      category: 'food',
      date: '29 Sept 2023, 18:43PM',
      groupId: '2')
];

List<Bill> bills = const [
  Bill(
      'Bali Trip (Group)',
      'michael',
      'USDC',
      'Polygon',
      'TEGWc23432009023asda9asrR320923de09d',
      '10 October 2023',
      '-',
      'Not paid',
      '194.00'),
  Bill(
      'McDonald',
      'michael',
      'USDC',
      'Polygon',
      'TEGWc23432009023asda9asrR320923de09d',
      '10 October 2023',
      '-',
      'Settled',
      '5.00')
];
