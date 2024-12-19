import 'dart:io';

import 'package:admin_taag/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ImagesRepo 
{
  Future<Either<Failure, String>> uploadImage(File image);
  //
}