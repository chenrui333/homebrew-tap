class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "a832e1a2c687222a011a0a29ccbe9c025a4413c4894b1f1c014e0f6d8927e639"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c896f34f48cda5b88118b481fc77b4d269e1c19eee2c5a698c369458c53d777e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c896f34f48cda5b88118b481fc77b4d269e1c19eee2c5a698c369458c53d777e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c896f34f48cda5b88118b481fc77b4d269e1c19eee2c5a698c369458c53d777e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fab42d00773df9a1ebbce86908ac8916337e033503de5c7890b17dfbc1b361c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fab42d00773df9a1ebbce86908ac8916337e033503de5c7890b17dfbc1b361c"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "git", "init"
    system "git", "add", "."
    system "gem", "build", "openclacky.gemspec"
    system "gem", "install", "--no-document", "openclacky-#{version}.gem"

    %w[clacky openclacky clarky].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin"/cmd, GEM_HOME: ENV["GEM_HOME"]
    end
  end

  test do
    assert_match "agent", shell_output("#{bin}/clacky help")
    assert_match "Commands", shell_output("#{bin}/openclacky help")
  end
end
