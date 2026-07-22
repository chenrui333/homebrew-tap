class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "26273edb2aadc0bf5e8938efed62961c94ed8d11324fec931763aadda165875a"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bec65d227335b354967c14c5e5994e4e40e6756b22bd4581e086a4775c48c885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bec65d227335b354967c14c5e5994e4e40e6756b22bd4581e086a4775c48c885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec65d227335b354967c14c5e5994e4e40e6756b22bd4581e086a4775c48c885"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2ed0cb5c2231b3117ad501a6691db737386d9affc42b9563644382ab5ee4380"
    sha256 cellar: :any,                 x86_64_linux:  "7b130dbd820219af0521523a6ca6162bbef14eca92071d2c1c6fd6e68a45175c"
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
