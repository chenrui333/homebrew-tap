class Hapi < Formula
  desc "Agentic coding - access coding agent anywhere"
  homepage "https://github.com/tiann/hapi"
  url "https://registry.npmjs.org/@twsxtd/hapi/-/hapi-0.16.5.tgz"
  sha256 "f7d559edd854ea2a64a2e8f32efe91e38061837d9d9ec8e5c1c2fcc7cad43b16"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "dacff15601beafb8a496662b275accaf4c3d8a924f2b8d319e9d77210d279dd6"
    sha256                               arm64_sequoia: "dacff15601beafb8a496662b275accaf4c3d8a924f2b8d319e9d77210d279dd6"
    sha256                               arm64_sonoma:  "dacff15601beafb8a496662b275accaf4c3d8a924f2b8d319e9d77210d279dd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed197a4227bcb981722f563cdaed779783ec38ea527348fe83ad2787b6d046aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301ec54e1c8ce15a4e65708eda9b4e953a5d2e88751dcf0339a6294060f607e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hapi --version")
    assert_match "📋 Basic Information", shell_output("#{bin}/hapi doctor")
  end
end
