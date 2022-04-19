if executable('clang-format')
	setlocal formatprg=clang-format
end

if !executable('cmake')
	finish
end

if filereadable('CMakeLists.txt') 
	setlocal makeprg=cmake\ --build\ .
end
