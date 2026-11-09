class CcBridge < Formula
  desc "Live JSONL message bridge between local Claude Code sessions"
  homepage "https://github.com/Incultnitollc/claude-code-live-bridge"
  url "https://registry.npmjs.org/@incultnitollc/cc-bridge/-/cc-bridge-0.1.0.tgz"
  sha256 "803e6d257e03cb628523071070b8f15e3b0687c581ab64897438c0de82b2a087"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "862639e591c19b767b5b6dd4078047511570ae862285a66251decccf7b65ef77"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["CC_BRIDGE_HOME"] = testpath/"bridge"
    assert_match version.to_s, shell_output("#{bin}/cc-bridge --version")

    id = shell_output("#{bin}/cc-bridge send 'homebrew round-trip' --room homebrew --from brew-test").strip
    room_file = testpath/"bridge/rooms/homebrew.jsonl"
    messages = room_file.readlines.map { |line| JSON.parse(line) }
    assert_equal 1, messages.length
    assert_equal "homebrew", messages.first["room"]
    assert_equal "brew-test", messages.first["from"]
    assert_equal "homebrew round-trip", messages.first["msg"]
    assert_match(/\A[0-9A-HJKMNP-TV-Z]{26}\z/, id)
    assert_equal id, messages.first["id"]
    assert_equal "OK: 1 valid lines\n", shell_output("#{bin}/cc-bridge validate #{room_file}")
  end
end
