{ inputs, ... }: {
  # Set Git commit hash for version
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
