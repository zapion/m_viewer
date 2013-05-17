# Make file of install Marionette viewer
#
DOC=$(HOME)/.vim/doc/m_viewer.txt

all: install uninstall

install:
	@echo "check m_viewer(Marionette Viewer) status ...."	
	@if ! [ -f $(HOME)/.vim/doc/m_viewer.txt ];then \
		echo "start to copy m_viewer into $(HOME)/.vim ...."; \
		cp -rf .vim $(HOME)/; \
		echo "m_viewer installed successfully"; \
	else \
		echo "nothing to install"; \
	fi

uninstall:
	@echo "check m_viewer(Marionette Viewer) status ...."	
	@if [ -f $(HOME)/.vim/doc/m_viewer.txt ];then \
		echo "start to remove m_viewer from $(HOME)/.vim ..."; \
		rm -f $(HOME)/.vim/doc/m_viewer.txt; \
		rm -f $(HOME)/.vim/plugin/m_viewer.vim; \
		rm -f $(HOME)/.vim/plugin/m_viewer_client.py; \
		rm -f $(HOME)/.vim/plugin/m_viewer_client.pyc; \
		echo "m_viewer uninstalled"; \
	else \
		echo nothing to clean; \
	fi; 
