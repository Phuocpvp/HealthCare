import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { BodyIndex } from 'src/schema/bodyIndex.schema';
import { HealthTracking, HealthTrackingDocument } from 'src/schema/healthTracking.schema';
import { Sleep } from 'src/schema/sleep.schema';
import { User } from 'src/schema/user.schema';

@Injectable()
export class HealthTrackingService {
  constructor(
    @InjectModel(HealthTracking.name) private healthTrackingModel: Model<HealthTrackingDocument>,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}

  async createEmptyHealthTracking(userId: string): Promise<HealthTracking> {
    // Kiểm tra xem userId có tồn tại trong bảng User không
    const user = await this.userModel.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
  
    // Tạo và lưu bản ghi mới cho HealthTracking với các trường mặc định (rỗng)
    const healthTracking = new this.healthTrackingModel({
      user: user._id, // Liên kết với user qua _id
      Day: new Date(), // Ngày hiện tại (hoặc có thể đặt mặc định là một giá trị khác)
      BODYINDEX: { weight: 0, height: 0, bmi: 0 }, // Giá trị mặc định cho BODYINDEX
    SLEEP: { sleepTime: 0, Start: new Date(), End: new Date() }, // Giá trị mặc định cho SLEEP
    });
  
    // Lưu vào cơ sở dữ liệu và trả về bản ghi vừa tạo
    return healthTracking.save();
  }

  // Phương thức tạo mới HealthTracking, sử dụng schema trực tiếp
  async createHealthTracking(userId: string, createHealthTrackingData: HealthTracking): Promise<HealthTracking> {
    // Kiểm tra xem userId có tồn tại trong bảng User không
    const user = await this.userModel.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }

    // Tạo và lưu bản ghi mới cho HealthTracking
    const healthTracking = new this.healthTrackingModel({
      user: user._id,
      Day: createHealthTrackingData.Day.getDate,
      BODYINDEX: createHealthTrackingData.BODYINDEX,
      SLEEP: createHealthTrackingData.SLEEP,
    });

    // Lưu vào cơ sở dữ liệu và trả về bản ghi vừa tạo
    return healthTracking.save();
  }

  async findAll(): Promise<HealthTracking[]> {
    return this.healthTrackingModel.find().exec();
  }

  async findOne(id: string): Promise<HealthTracking> {
    const healthTracking = await this.healthTrackingModel.findById(id).exec();
    if (!healthTracking) {
      throw new Error(`HealthTracking with ID ${id} not found`);
    }
    return healthTracking;
  }

  async update(id: string, updateHealthTrackingData: Partial<HealthTracking>): Promise<HealthTracking> {
    const updatedHealthTracking = await this.healthTrackingModel
      .findByIdAndUpdate(id, updateHealthTrackingData, { new: true })
      .exec();
    if (!updatedHealthTracking) {
      throw new Error(`HealthTracking with ID ${id} not found`);
    }
    return updatedHealthTracking;
  }

  async updateSleep(userId: string, sleepData: Sleep): Promise<HealthTracking> {
    // Kiểm tra xem userId có tồn tại trong bảng User không
    const user = await this.userModel.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
  
    // Kiểm tra xem user có bản ghi HealthTracking không, nếu không tạo mới
    let healthTracking = await this.healthTrackingModel.findOne({ user: user._id });
    if (!healthTracking) {
      // Tạo mới HealthTracking nếu không tồn tại
      healthTracking = new this.healthTrackingModel({
        user: user._id,
        SLEEP: sleepData,
      });
    } else {
      // Cập nhật SLEEP trong HealthTracking
      healthTracking.SLEEP = sleepData;
    }
  
    // Lưu lại bản ghi cập nhật
    return healthTracking.save();
  }
  
  async updateBodyIndex(userId: string, bodyIndexData: BodyIndex): Promise<HealthTracking> {
    // Kiểm tra xem userId có tồn tại trong bảng User không
    const user = await this.userModel.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }
  
    // Tìm bản ghi HealthTracking của user, nếu không có thì tạo mới
    let healthTracking = await this.healthTrackingModel.findOne({ user: user._id });
  
    if (!healthTracking) {
      // Nếu không có bản ghi HealthTracking thì tạo mới và gán BODYINDEX vào
      healthTracking = new this.healthTrackingModel({
        user: user._id,
        BODYINDEX: bodyIndexData,
      });
    } else {
      // Nếu có bản ghi HealthTracking rồi, thì cập nhật BODYINDEX
      healthTracking.BODYINDEX = bodyIndexData;
    }
  
    // Lưu lại bản ghi HealthTracking
    return healthTracking.save();
  }

  async remove(id: string): Promise<string> {
    const result = await this.healthTrackingModel.findByIdAndDelete(id).exec();
    if (!result) {
      throw new Error(`HealthTracking with ID ${id} not found`);
    }
    return `HealthTracking with ID ${id} has been removed`;
  }
}
