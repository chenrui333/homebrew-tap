class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "8d56742bc18622063cf4ce45c2adb4f9bf493f31b14bfe6187b5dd9f8462a00e"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ed5154bce6786900f48f99b6125dd6c7cb956afcd0443173fda9fe877bd2f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7ed5154bce6786900f48f99b6125dd6c7cb956afcd0443173fda9fe877bd2f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7ed5154bce6786900f48f99b6125dd6c7cb956afcd0443173fda9fe877bd2f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d9b19f3b4db3afb0482db47f26c1a0485b9f057e15a1dd1bb851628f3ac1fa"
    sha256 cellar: :any,                 x86_64_linux:  "571dd1f82442979b2ff1c379c90c4d7137ecdd56acd13b29de713b5a8791047f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    config_dir = testpath/".config"/"treekanga"
    config_dir.mkpath
    (config_dir/"treekanga.yaml").write("repos: {}\n")

    (testpath/"source").mkpath
    cd testpath/"source" do
      system "git", "init", "-b", "main"
      (testpath/"source"/"README.md").write("hello\n")
      system "git", "add", "README.md"
      system "git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-m", "init"
    end

    (testpath/"workspace").mkpath
    with_env(HOME: testpath.to_s) do
      cd testpath/"workspace" do
        output = shell_output("#{bin/"treekanga"} clone #{testpath/"source"}")
        assert_match "Successfully cloned source_bare", output
        assert_path_exists testpath/"workspace"/"source_bare"/"HEAD"
        assert_path_exists testpath/"workspace"/"source_bare"/"config"
      end
    end
  end
end
