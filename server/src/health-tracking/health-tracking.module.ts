import { Module } from '@nestjs/common';
import { HealthTrackingService } from './health-tracking.service';
import { HealthTrackingController } from './health-tracking.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { HealthTracking, HealthTrackingSchema } from 'src/schema/healthTracking.schema';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: HealthTracking.name, schema: HealthTrackingSchema }]),
    UserModule,
],
  controllers: [HealthTrackingController],
  providers: [HealthTrackingService],
  // exports:[HealthTrackingService],
})
export class HealthTrackingModule {}
