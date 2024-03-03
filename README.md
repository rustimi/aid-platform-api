# Aid Platform API

## Overview

This document outlines the main functionalities of the Aid platform's API.

## API Endpoints

### Users

- **GET `/users`**: Retrieve information about the current user.
- **PUT `/users`**: Create a new user.
- **PATCH `/users`**: Update information for the current user.
- **DELETE `/users`**: Delete the current user.

### User Requests

- **GET `/users/requests`**: Show all requests associated with the current user.
- **POST `/users/requests/:id/republish`**: Republish a request by its ID.
- **POST `/users/requests/:id/fulfill`**: Mark a request as fulfilled.

### Requests

- **GET `/requests`**: List all requests. Authenticated users will see all requests they can volunteer for.
- **PUT `/requests`**: Create a new request.
- **GET `/requests/:id`**: Show details of a specific request.
- **PATCH `/requests/:id`**: Update a request.
- **DELETE `/requests/:id`**: Delete a request.
- **POST `/requests/:id/volunteer`**: Volunteer for a request.

### Conversations

- **GET `/conversations/index`**: List all conversations associated with a request.
- **GET `/requests/:id/conversations`**: List all conversations for a specific request.
- **GET `/requests/:id/conversations/:conversation_id/messages`**: Show all messages within a conversation.
- **PUT `/requests/:id/conversations/:conversation_id/messages`**: Add a new message to a conversation.

### Messages

- **GET `messages/index`**: Show all messages of a conversation.

### Authentication

- **POST `/login`**: Login endpoint for authentication.

### Uploads

- **POST `/upload`**: Upload a picture for the user.

## Getting Started

To get started with the API, first ensure you have Ruby on Rails installed. Clone the repository to your local machine and navigate to the application directory. Run `bundle install` to install the dependencies, followed by `rails db:migrate` to set up the database. Start the Rails server with `rails s`, and you can begin making requests to the endpoints listed above.

## Authentication

Some endpoints require user authentication. Please ensure you are authenticated before attempting to access these endpoints. Use the `/login` endpoint to authenticate.

## Contributing

We welcome contributions to improve the application. Please feel free to fork the repository, make your changes, and submit a pull request.
