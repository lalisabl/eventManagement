import mongoose, { Document, Schema, Model } from 'mongoose';

interface IFavorite extends Document {
  userId: mongoose.Schema.Types.ObjectId;
  eventId: mongoose.Schema.Types.ObjectId;
}

const favoriteSchema: Schema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    eventId: {
      type: Schema.Types.ObjectId,
      ref: 'Event',
      required: true,
    },
  },
  { timestamps: true }
);

const Favorite: Model<IFavorite> = mongoose.model<IFavorite>('Favorite', favoriteSchema);

export default Favorite;
