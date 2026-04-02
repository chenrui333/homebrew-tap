class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v1.0.1.tar.gz"
  sha256 "c0802067f729aabb5bd9605873dbc5e1cdba2d135dece16f0e409fab0e339a3d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "582cf0044eb582e451e96151ac2fd044d5c3d139ee09a02d0e7c6c680d133353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "193ec63346e8840a245260f81e94d7ce0bf96aca0095e80bf8e723feecd4b14d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4437b200aa88a60b50f395c8ca0d60dd86064dce056fd7f2685d109af2127607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e2406698e415bc9a2a557910e6d3f1d5ab992a59262f10c99d8844ac043ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a478b11a9afefad5f204eba825ddeb6fb3fe2e3851a12bdeeba0165340a4ef72"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
