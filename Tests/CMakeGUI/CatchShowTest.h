/* Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
   file LICENSE.rst or https://cmake.org/licensing for details.  */
#pragma once

#include <QObject>

class CatchShowTest : public QObject
{
  Q_OBJECT
public:
  CatchShowTest(QObject* parent = nullptr);

private slots:
  void catchShow();
};
