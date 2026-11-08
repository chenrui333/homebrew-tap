class Termtastic < Formula
  desc "Meshtastic console client"
  homepage "https://github.com/acelot/termtastic"
  url "https://github.com/acelot/termtastic/archive/refs/tags/v1.0.0-alpha7.tar.gz"
  sha256 "b1d852b1f219b81ca1f7e7a083b7b0ef461e37fadf1adce3f93789ec15b9e078"
  license "GPL-3.0-only"
  head "https://github.com/acelot/termtastic.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["GIT_REF_TYPE"] = "tag"
    ENV["GIT_REF_NAME"] = "v#{version}"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termtastic --version")

    # Fail before radio discovery by making the application data directory unwritable.
    (testpath/"blocked").write "not a directory"
    output = shell_output("XDG_DATA_HOME=#{testpath}/blocked #{bin}/termtastic 2>&1", 101)
    assert_match "initializing rolling file appender failed", output
  end
end
