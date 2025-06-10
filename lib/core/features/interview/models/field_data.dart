class FieldData {
  static final Map<String, List<String>> fieldTechnologies = {
    'Frontend': ['React', 'Angular', 'Vue.js', 'Svelte'],
    'Backend': ['Node.js', 'Python', 'Java', 'PHP', 'Ruby'],
    'Mobile': ['Flutter', 'React Native', 'Swift', 'Kotlin'],
    'Devops': [
      'Linux',
      'Docker',
      'Kubernetes',
      'Terraform',
      'AWS',
      'Azure',
      'CI/CD',
      'Monitoring',
    ],
    'UI/UX Design': ['Figma', 'Adobe XD', 'Sketch'],
    'Data Analysis': ['Python', 'R', 'SQL', 'Tableau'],
    'Data Science': ['Python', 'R', 'TensorFlow', 'PyTorch'],
    'Cyber Security': [
      'Network Security',
      'Application Security',
      'Cloud Security',
    ],
  };

  static final Set<String> multiSelectTracks = {
    'Devops',
    'Cyber Security',
    'Data Analysis',
    'Data Science',
  };

  static final List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
}