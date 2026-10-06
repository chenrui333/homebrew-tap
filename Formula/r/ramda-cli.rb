class RamdaCli < Formula
  desc "CLI tool for processing data with functional pipelines"
  homepage "https://github.com/raine/ramda-cli"
  url "https://registry.npmjs.org/ramda-cli/-/ramda-cli-6.0.0.tgz"
  sha256 "cb7a69f9ad7b02f03c1f2178aa071dab5094f85d56ff44d12d0a8c6f355c5f10"
  license "ISC"

  livecheck do
    skip "no new releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "820a17316d9758cb4dfd44be9cae81e6bba00f8ad6b2c7fae547470a506e31df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820a17316d9758cb4dfd44be9cae81e6bba00f8ad6b2c7fae547470a506e31df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0b14acecd97a10135f1f19da660d989d4945640ec5bf78bfb5a7b09287e006d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b14acecd97a10135f1f19da660d989d4945640ec5bf78bfb5a7b09287e006d"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/ramda"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ramda --version 2>&1", 1)

    (testpath/"people.json").write <<~JSON
      [
        {"name": "Dr. Araceli Lang", "city": "Yvettemouth", "mac": "9e:ea:28:41:2a:50"},
        {"name": "Terrell Boyle", "city": "Port Reaganfort", "mac": "c5:32:09:5a:f7:15"},
        {"name": "Jane Doe", "city": "Springfield", "mac": "00:11:22:33:44:55"},
        {"name": "Libby Renner", "city": "Port Reneeside", "mac": "9c:63:13:31:c4:ac"}
      ]
    JSON

    output = shell_output("#{bin}/ramda 'filter (p) -> p.city?.match /Port/ " \
                          "or p.name.match /^Dr\\./' 'map pick [\"name\", \"city\", " \
                          "\"mac\"]' 'take 3' -o table --compact < #{testpath}/people.json")
    assert_equal <<~EOS, output
      ┌──────────────────┬─────────────────┬───────────────────┐
      │ name             │ city            │ mac               │
      ├──────────────────┼─────────────────┼───────────────────┤
      │ Dr. Araceli Lang │ Yvettemouth     │ 9e:ea:28:41:2a:50 │
      │ Terrell Boyle    │ Port Reaganfort │ c5:32:09:5a:f7:15 │
      │ Libby Renner     │ Port Reneeside  │ 9c:63:13:31:c4:ac │
      └──────────────────┴─────────────────┴───────────────────┘
    EOS
  end
end
