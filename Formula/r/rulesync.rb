class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.55.0.tgz"
  sha256 "a3a0e707da0ab5e3c52d05d91f7256beb1c953545442da4d39fd5de89202d6b8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a57d38a573d7b9d05f2326e9faa8ea83f58122282c8764162e3412fa0097ed01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac8aa291fc3b0f0e48967b85d8bb1a02876c07f5fc37db7ba02b3e87faf40250"
    sha256 cellar: :any_skip_relocation, ventura:       "0fe4a83c178d28e3a05b75a69e44ddb09d1da538ed128472cb59b6ba5dbb83ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "473608f112a45795834befa248f13e6aafb3ab948cd9a12270eb87108309e1b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/overview.md").read

    output = shell_output("#{bin}/rulesync status")
    assert_match ".rulesync directory: ✅ Found", output
  end
end
