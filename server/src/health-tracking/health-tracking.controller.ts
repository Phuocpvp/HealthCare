import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Put,
} from '@nestjs/common';
import { HealthTrackingService } from './health-tracking.service';
import { HealthTracking } from 'src/schema/healthTracking.schema';
import { Sleep } from 'src/schema/sleep.schema';
import { BodyIndex } from 'src/schema/bodyIndex.schema';

@Controller('health-tracking')
export class HealthTrackingController {
  constructor(private readonly healthTrackingService: HealthTrackingService) {}

  // Lấy tất cả HealthTracking
  @Get()
  async findAll(): Promise<HealthTracking[]> {
    return this.healthTrackingService.findAll();
  }

  // Lấy HealthTracking theo ID
  @Get(':id')
  async findOne(@Param('id') id: string): Promise<HealthTracking> {
    return this.healthTrackingService.findOne(id);
  }

  @Post('create-empty/:userId')
  async createEmptyHealthTracking(
    @Param('userId') userId: string,
  ): Promise<HealthTracking> {
    return this.healthTrackingService.createEmptyHealthTracking(userId); // Gọi service để tạo HealthTracking mới
  }

  // Tạo mới HealthTracking
  @Post(':userId')
  async create(
    @Param('userId') userId: string,
    @Body() createHealthTracking: HealthTracking,
  ): Promise<HealthTracking> {
    return this.healthTrackingService.createHealthTracking(
      userId,
      createHealthTracking,
    );
  }

  // Cập nhật HealthTracking theo ID
  @Put(':id')
  async update(
    @Param('userId') id: string,
    @Body() updateHealthTracking: HealthTracking,
  ): Promise<HealthTracking> {
    return this.healthTrackingService.update(id, updateHealthTracking);
  }

  // Cập nhật SLEEP
  @Put('sleep/:userId')
  async updateSleep(
    @Param('userId') userId: string,
    @Body() sleepData: Sleep,
  ) {
    return this.healthTrackingService.updateSleep(userId, sleepData);
  }

  @Post('update-bodyindex/:userId')
  async updateBodyIndex(
    @Param('userId') userId: string,
    @Body() bodyIndexData: BodyIndex,
  ): Promise<HealthTracking> {
    return this.healthTrackingService.updateBodyIndex(userId, bodyIndexData);
  }

  // Xóa HealthTracking theo ID
  @Delete(':id')
  async remove(@Param('id') id: string): Promise<string> {
    return this.healthTrackingService.remove(id);
  }
}
