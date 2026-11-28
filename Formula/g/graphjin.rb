class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.27.3.tar.gz"
  sha256 "a366517a1209b4a88e49aff851dfb56165bb3d2bd2a27d5350ebd71d6bebafa9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8e206e2ba0985d6ee25baaa28779310ec3e45f477ea34debadffd74a2498604d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "837273563ffae0352c91efe8273133f1e35e0e5762b53735c6b8c8a3c6555f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37bc127b86b53aec0e3521203a0627795e204c12bc9f6b55b6efa0b8eb8fd11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04eadd2fb8144fb30faa797187b41119b26f9a89d045b3dde1d64fe0e69793df"
    sha256 cellar: :any,                 x86_64_linux:  "ec480f551b01494b60360e6b98210abc914c5028cff122eba815019880ca5079"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
