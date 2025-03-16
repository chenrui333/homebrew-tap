class Goboscript < Formula
  desc "Scratch compiler"
  homepage "https://aspizu.github.io/goboscript/"
  url "https://github.com/aspizu/goboscript/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "79a2749dbcaa6420c0a17f6259a7ba80cd7fedeec7360e1cc217d6c8e114ae96"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d964aa661c8e62b3ed0a82c03c890ec939758ce582575e3cbe7209a95639e170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a429dc8cc4e9d92c29bdcf6cfcbd39ca6651e03a3a319ee0c752aca00291feae"
    sha256 cellar: :any_skip_relocation, ventura:       "c7b224b38ce00d3c47d8893cfce62cf61679fe63dd71756c618fbf10cd98d0a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d20ba3eed47a7a0c32c67eef116a6f68afc36927819bd4c090c8a27e9ac8ccef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"goboscript", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goboscript --version")

    # test scratch file
    scratch_file = testpath/"test.scratch"
    scratch_file.write <<~SCRATCH
      when gf clicked
      say [Hello, world!]
    SCRATCH

    system bin/"goboscript", "fmt", "-i", scratch_file

    system bin/"goboscript", "new", "--name", "brewtest"
    assert_path_exists testpath/"brewtest/goboscript.toml"
  end
end
