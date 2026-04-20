class GetShitDoneCc < Formula
  desc "Meta-prompting and context engineering system for AI coding agents"
  homepage "https://github.com/gsd-build/get-shit-done"
  url "https://github.com/gsd-build/get-shit-done/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "f21a8251554be7eda41ec7862c6c67ab24a276ec85a1cfd9cb3b879885a82742"
  license "MIT"
  head "https://github.com/gsd-build/get-shit-done.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1fb755e49a744ebee2de532618993d96b5774f9238e087fd946cb4289371b561"
  end

  depends_on "node"

  def install
    system "npm", "run", "build:hooks"
    libexec.install Dir["*"]
    node_modules = libexec/"node_modules"
    node_modules.mkpath
    (bin/"get-shit-done-cc").write_env_script libexec/"bin/install.js",
                                              PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    output = shell_output("#{bin}/get-shit-done-cc --help")
    assert_match "Get Shit Done", output
    assert_match version.to_s, output
  end
end
