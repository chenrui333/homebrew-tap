class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0f562d58c2f133145e90afbabcb29f64537d27dff4c6e53d112c758bc85cd1ea"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcfbe8159cf7c71a8e34b91839ef15413d6127d774ee7ff707082336b28f4590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcfbe8159cf7c71a8e34b91839ef15413d6127d774ee7ff707082336b28f4590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcfbe8159cf7c71a8e34b91839ef15413d6127d774ee7ff707082336b28f4590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b29e0f6918eab6c66071cfb574513d2d0a0aa0de7999988bee11008dd97bb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae574b4b529e9ddd96b3c4011fab8a4807737ac354cb7380a5eba4db2fd21fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/boolean-maybe/tiki/config.Version=#{version}
      -X github.com/boolean-maybe/tiki/config.GitCommit=Homebrew
      -X github.com/boolean-maybe/tiki/config.BuildDate=unknown
    ]

    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    output = shell_output("#{bin/"tiki"} sysinfo")
    assert_match "System Information", output
    assert_match "OS:", output
    assert_match "Project Root:", output

    assert_match version.to_s, shell_output("#{bin/"tiki"} --version")
  end
end
