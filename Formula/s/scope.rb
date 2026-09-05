class Scope < Formula
  desc "Serial monitor with scripting support"
  homepage "https://github.com/matheuswhite/scope-rs"
  url "https://github.com/matheuswhite/scope-rs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "38b960bc5d449a8ccd869e3a6b0b5dd35088310462d1b90a19624eb4c4b4bbf2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/matheuswhite/scope-rs.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"scope", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scope --version")
    output = shell_output("#{bin}/scope --name '' list 2>&1", 1)
    assert_match "session name cannot be empty", output
  end
end
