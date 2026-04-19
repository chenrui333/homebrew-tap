class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.7.tgz"
  sha256 "071327841df03100071bff2029ee68906ddf4b65f362b887413bb25e2014a782"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "086b7584946f97d51131f79c3c0cb763394016950f092f0038a53d8b90d1e9f1"
    sha256                               arm64_sequoia: "086b7584946f97d51131f79c3c0cb763394016950f092f0038a53d8b90d1e9f1"
    sha256                               arm64_sonoma:  "086b7584946f97d51131f79c3c0cb763394016950f092f0038a53d8b90d1e9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a44eec1bd4716e0ef8cc514727453253e534a9345e3c51b9587bed05069b47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "721151d91bb58888361d4dfed4a2cdf0c87f29ba405569da33e2ba842363f03d"
  end

  depends_on "node"

  def install
    # Required for the platform-specific optional binary package on CI mirrors.
    ENV["npm_config_registry"] = "https://registry.npmjs.org"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
