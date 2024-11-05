import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { User, UserDocument } from 'src/schema/user.schema';
import { RegisterDTO } from './dto/register.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    // private jwtService: JwtService,

 ) {}

 async register(register : RegisterDTO) {
    const hashedPassword = await bcrypt.hash(register.password, 10);
    const newUser = new this.userModel({
      ...register,
       password: hashedPassword,
    });
    return newUser.save();
 }

}
