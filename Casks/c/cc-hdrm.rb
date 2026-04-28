cask "cc-hdrm" do
  version "1.4.2"
  sha256 "dc0bc570ad7714354083b596aba93c37e7f5297a36f7f558360b73049f34e5ec"

  url "https://github.com/rajish/cc-hdrm/releases/download/v#{version}/cc-hdrm-#{version}.dmg"
  name "cc-hdrm"
  desc "Menu bar utility showing Claude subscription session headroom"
  homepage "https://github.com/rajish/cc-hdrm"

  depends_on macos: ">= :sonoma"

  app "cc-hdrm.app"
end
