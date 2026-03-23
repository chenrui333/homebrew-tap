class GhDash < Formula
  desc "Terminal UI for GitHub"
  homepage "https://github.com/dlvhdr/gh-dash"
  url "https://github.com/dlvhdr/gh-dash/archive/refs/tags/v4.23.2.tar.gz"
  sha256 "aef43a5998fa16447a832797484984ed8894b65c94acebc17f8210c2b3b4b687"
  license "MIT"

  depends_on "go" => :build
  depends_on "gh"

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/dlvhdr/gh-dash/v4/cmd.Version=#{version}
      -X github.com/dlvhdr/gh-dash/v4/cmd.Commit=Homebrew
      -X github.com/dlvhdr/gh-dash/v4/cmd.Date=unknown
      -X github.com/dlvhdr/gh-dash/v4/cmd.BuiltBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gh-dash")
  end

  test do
    (testpath/"bad.yml").write <<~YAML
      foo: [
    YAML

    output = shell_output("#{bin}/gh-dash --config #{testpath/"bad.yml"} 2>&1", 1)
    assert_match "failed parsing config file", output
    assert_match version.to_s, shell_output("#{bin}/gh-dash --version")
  end
end
