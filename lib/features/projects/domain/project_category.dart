/// How a project is organized in the portfolio (US41).
enum ProjectCategory { game, website, tool }

String projectCategoryLabel(ProjectCategory category) => switch (category) {
  ProjectCategory.game => 'Jeu',
  ProjectCategory.website => 'Site',
  ProjectCategory.tool => 'Outil',
};
