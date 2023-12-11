export type MovieCreated = {
  id: string;
  title: string;
  rating: number;
  genres: string[];
};

export type MovieDeleted = {
  id: string;
};

export type MovieUpdated = {
  id: string;
  title: string;
  rating: number;
  genres: string[];
};

export const MovieCreatedEventType = "MovieCreated";
export const MovieDeletedEventType = "MovieDeleted";
export const MovieUpdatedEventType = "MovieUpdated";
