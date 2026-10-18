class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.15.tar.gz"
  sha256 "032350a9e8693ce24adde9e7a9b2fdc7497ba90f262bbc5fa50798deefdc4ff9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd1046fb75601631cf99ae1291ce96fe6a6e204d46812251f0598a54c7e376c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78e69ea030307ee56e4aa6ff413d67b127ee6cf06b4bcef974d522e62d35fbff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d94a02f7b10281ddeeb105d07aa97f0d4eb0c468a361c9b5ade53221e93db93"
    sha256 cellar: :any,                 x86_64_linux:  "1bf2a4097df26529e965f449b5d3848cd4d83fb6cd85e747c1f19a83359cb3a4"
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
