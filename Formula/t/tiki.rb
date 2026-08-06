class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c9a80bf800859a77cc6ba004e896917880b23b8fd280ac889de2482e6a26997b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "154ad0ba5139b4dbb3249ad3c0dd33168d0250f077a3814d84f533cf039c42aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154ad0ba5139b4dbb3249ad3c0dd33168d0250f077a3814d84f533cf039c42aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "154ad0ba5139b4dbb3249ad3c0dd33168d0250f077a3814d84f533cf039c42aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba53dce5f4076c09c86d77d56383bbf9b6cc5591f3fd6bbe6215ccb82ab6f6b9"
    sha256 cellar: :any,                 x86_64_linux:  "383e99389a5b5b263dd728c8fae0f94ee6f576d32a86fc1bf96cd4511f6a888f"
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
