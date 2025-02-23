class RamdaCli < Formula
  desc "CLI tool for processing data with functional pipelines"
  homepage "https://github.com/raine/ramda-cli"
  url "https://registry.npmjs.org/ramda-cli/-/ramda-cli-6.0.0.tgz"
  sha256 "cb7a69f9ad7b02f03c1f2178aa071dab5094f85d56ff44d12d0a8c6f355c5f10"
  license "ISC"

  livecheck do
    skip "no new releases"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/ramda"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ramda --version 2>&1", 1)

    output = shell_output("curl -Ls https://bit.ly/gist-people-json | " \
                          "#{bin}/ramda 'filter (p) -> p.city?.match /Port/ " \
                          "or p.name.match /^Dr\\./' 'map pick [\"name\", \"city\", " \
                          "\"mac\"]' 'take 3' -o table --compact")
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
