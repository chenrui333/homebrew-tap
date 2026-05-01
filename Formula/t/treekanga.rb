class Treekanga < Formula
  desc "Manage Git worktrees from the command-line"
  homepage "https://github.com/garrettkrohn/treekanga"
  url "https://github.com/garrettkrohn/treekanga/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e0d191e072afc2a77a58ee53f405cb789a99989ec77a708b66a62ce2a051bef7"
  license :cannot_represent
  head "https://github.com/garrettkrohn/treekanga.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48137ca1c4d3048643a8e933e5c663094c355637e31c01b25199b35517683a23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48137ca1c4d3048643a8e933e5c663094c355637e31c01b25199b35517683a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48137ca1c4d3048643a8e933e5c663094c355637e31c01b25199b35517683a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89a9c4e1bb7f43c3bf42e43a8fbf6060a5016d4189e56eadd13ca2a7fddde3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa7c8b382d8cd571b86ecdbed2f6640ba6e0bb7546e35fd62f828dc8d8a2c65"
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
