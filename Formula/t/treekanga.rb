class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e950786fb76a012c63c887abe5b794c2533b265e96e90d67def35700c716cd2e"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0407617108f0b246b19bd20b1b0f57f4fd8432b255b6d7c2f094c2ca445c9862"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0407617108f0b246b19bd20b1b0f57f4fd8432b255b6d7c2f094c2ca445c9862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0407617108f0b246b19bd20b1b0f57f4fd8432b255b6d7c2f094c2ca445c9862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c4a8d455e524aa3532ec7e25b4d9f6f4d868b91eb13077297358c29ab6870ff"
    sha256 cellar: :any,                 x86_64_linux:  "ff439369442d10897047a21d9e94ac57f4070b4bb4a7c7ebecfbd428e1ebdc68"
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
