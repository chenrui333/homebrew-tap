class Tempo < Formula
  desc "Terminal client for Temporal"
  homepage "https://github.com/galaxy-io/tempo"
  url "https://github.com/galaxy-io/tempo/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "68e2993c5ccfca49dc6302ecbfc41186ec05361ab55ea09afcec3dd7c4e159ba"
  license "MIT"
  head "https://github.com/galaxy-io/tempo.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/galaxy-io/tempo/internal/update.Version=#{version}"), "./cmd/tempo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tempo --version")
    output = shell_output("#{bin}/tempo --profile homebrew-missing 2>&1", 1)
    assert_match 'profile "homebrew-missing" not found', output
  end
end
