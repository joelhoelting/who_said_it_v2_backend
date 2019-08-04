# Models

## User

- email: string
- password: string

## Game

- difficulty: string
- state: text (serialize JSON)
- ten_quote_ids: text (serialize Array)
- completed: boolean

## Character

- slug: string
- name: string
- description: string

## Quote

- content: string
- source: string

# Database Associations

## User

- Has many games

## Game

- Belongs to User (optional: true)
- Has and Belongs Many Characters
- Has many quotes through characters

## Character

- Has and Belongs Many Games
- Has Many Games (through join table)
- Has Many Quotes

## Quote

- Belongs to Character
