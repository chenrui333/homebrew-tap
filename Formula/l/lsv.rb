class Lsv < Formula
  desc "Three Pane Terminal File Viewer"
  homepage "https://github.com/SecretDeveloper/lsv"
  url "https://static.crates.io/crates/lsv/lsv-0.1.14.crate"
  sha256 "0198dddefbe6fa429a6da2df16609974f4ad4402232c81f138689d318caf0b32"
  license "MIT"
  head "https://github.com/SecretDeveloper/lsv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77516d9e3734484c190eff5f92f29d48f4d2541460a945593749369f12acabd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "703af1e6ed1efd5c406abd05bd9c3ac04b3be2b8435d9b3832c812800b9d598d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf64b568d293f16d8d4ae40a946b228fc0849484eee4c750ac209e67f4e8fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e422b57b5f020ea11ed5bd3c8cbbc373f1ac3037d737cdd1999917ecefe144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be6ffde98da45c22821b1bb2bd93db19bc5d276121d094f2fd21bb185de1f8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsv --version")

    output = pipe_output("#{bin}/lsv --init-config", "y\n", 0)
    assert_match "This will create lsv config at: #{testpath}/.config/lsv", output
    assert_match "About config.context passed to actions", (testpath/".config/lsv/init.lua").read
  end
end
