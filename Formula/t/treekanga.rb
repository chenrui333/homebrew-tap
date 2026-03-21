class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "37eb5f7d89c5bba36dfd325cbacff0630dbffdd8ca238cf85169c79618efdafc"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3050cfde2278c4d09259d1def8ca6570d9919d0252a4aa8cae33a4157739f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3050cfde2278c4d09259d1def8ca6570d9919d0252a4aa8cae33a4157739f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3050cfde2278c4d09259d1def8ca6570d9919d0252a4aa8cae33a4157739f01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d55ee131e0f488b082faacaa0aa10ce1608d461fa2b9fe88c4e5bda665f51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af0f509cfe6ca779b029b0d0c18f80c3d15a37b9c24d28b88452e367c47fd21f"
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
    cd testpath/"workspace" do
      output = shell_output("#{bin}/treekanga clone #{testpath/"source"}")
      assert_match "Successfully cloned source_bare", output
      assert_path_exists testpath/"workspace"/"source_bare"/"HEAD"
      assert_path_exists testpath/"workspace"/"source_bare"/"config"
    end
  end
end
